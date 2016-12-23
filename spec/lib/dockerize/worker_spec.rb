require 'spec_helper'

module Dockerize
  describe Worker do

    after do
      subject.clean_up
    end

    before do
      allow_any_instance_of(Repository).to receive(:clone_url) {
        "spec/fixtures/docker-hello-world.git"
      }
    end

    let(:repository) do
      hash = JSON.parse(GithubHooks.repository_json)
      Repository.new(hash)
    end

    let(:logger) do
      nil
    end

    subject do
      described_class.new(repository: repository, logger: logger)
    end

    its(:repository)   { is_expected.to eq repository }
    its(:tmp_dir_base) { is_expected.to eq "/tmp/dockerize/dockerize" }
    its(:tmp_dir)      { is_expected.to eq "/tmp/dockerize/dockerize/lister/docker-hello-world" }
      
    context "update" do
      context "missing working copy" do
        it "has no working copy" do
          expect(Dir.exists?(subject.tmp_dir)).to be_falsey
        end

        it "creates a working copy" do
          git_dir_exists = subject.work { Dir.exists?(".git") }
          expect(git_dir_exists).to eq true
        end
      end

      context "existing working copy" do
        before { subject.work { } }

        it "has a working copy" do
          expect(Dir.exists?(subject.tmp_dir)).to be_truthy
        end

        it "creates a working copy" do
          git_dir_exists = subject.work { Dir.exists?(".git") }
          expect(git_dir_exists).to eq true
        end
       
      end
    end
  end
end
