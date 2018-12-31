# frozen_string_literal: true

# Monkey-patch the refused Rails 4.2 patch at
# https://github.com/rails/rails/pull/31330
#
# Updates sequence logic to support PostgreSQL 10.
#
# Came across this solution after writing the exemptions seed which attempts to
# reset the table's ID sequence as part of the seeding. Before the patch you
# would get the error
#
# `PG::UndefinedColumn: ERROR:  column "increment_by" does not exist`
#
# Googling identified this is because we are using Rails 4 to talk to PostgreSql
# 10. PostgreSql renamed the `increment_by` field to simply `increment` and only
# Rails 5 has been updated to recognise this. Heroku have a good write up of it
# it
# https://help.heroku.com/WKJ027JH/rails-error-after-upgrading-to-postgres-10
# https://github.com/rails/rails/issues/28780#issuecomment-354868174

require "active_record/connection_adapters/postgresql/schema_statements"

module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module SchemaStatements
        # Resets the sequence of a table's primary key to the maximum value.
        def reset_pk_sequence!(table, pk = nil, sequence = nil) #:nodoc:
          unless pk and sequence
            default_pk, default_sequence = pk_and_sequence_for(table)

            pk ||= default_pk
            sequence ||= default_sequence
          end

          if @logger && pk && !sequence
            @logger.warn "#{table} has primary key #{pk} with no default sequence"
          end

          if pk && sequence
            quoted_sequence = quote_table_name(sequence)
            max_pk = select_value("SELECT MAX(#{quote_column_name pk}) FROM #{quote_table_name(table)}")
            if max_pk.nil?
              if postgresql_version >= 100000
                minvalue = select_value("SELECT seqmin FROM pg_sequence WHERE seqrelid = #{quote(quoted_sequence)}::regclass")
              else
                minvalue = select_value("SELECT min_value FROM #{quoted_sequence}")
              end
            end

            select_value <<-end_sql, 'SCHEMA'
              SELECT setval(#{quote(quoted_sequence)}, #{max_pk ? max_pk : minvalue}, #{max_pk ? true : false})
            end_sql
          end
        end
      end
    end
  end
end
