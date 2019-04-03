# frozen_string_literal: true

require "rails_helper"
require "waste_exemptions_engine/privacy_policy_pdf_generator"

module WasteExemptionsEngine
  RSpec.describe PrivacyPolicyPdfGenerator do

    let(:tmp_path) { File.join(__dir__, "..", "tmp") }
    let(:pdf_file_path) { File.absolute_path(File.join(tmp_path, "privacy_policy.pdf")) }

    describe ".generate" do
      context "the 'tmp/'' directory doesn't exist" do
        before(:each) { FileUtils.remove_dir(tmp_path) if Dir.exist?(tmp_path) }

        it "automatically creates the directory" do
          described_class.generate
          expect(Dir.exist?(tmp_path)).to eq(true)
        end
      end

      context "the 'tmp/' directory already exists" do
        before(:each) { FileUtils.mkdir_p tmp_path }

        it "doesn't cause an error" do
          expect { described_class.generate }.not_to raise_error
          expect(Dir.exist?(tmp_path)).to eq(true)
        end
      end

      context "'privacy_policy.pdf' doesn't exist" do
        before(:each) { File.delete(pdf_file_path) if File.exist?(pdf_file_path) }

        it "creates the file" do
          described_class.generate
          expect(File.exist?(pdf_file_path)).to eq(true)
        end
      end

      context "'privacy_policy.pdf' already exists" do
        before(:each) do
          File.open(pdf_file_path, "w+") { |file| file.write("no peeking") }
        end

        it "doesn't cause an error" do
          expect { described_class.generate }.not_to raise_error
          expect(File.exist?(pdf_file_path)).to eq(true)
        end

        it "replaces the existing file" do
          before_generate_size = File.stat(pdf_file_path).size
          described_class.generate
          expect(before_generate_size).to be < File.stat(pdf_file_path).size
        end
      end

      it "returns the path to the generated pdf" do
        expect(described_class.generate).to eq(pdf_file_path)
      end
    end
  end
end
