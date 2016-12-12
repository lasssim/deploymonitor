require 'spec_helper'

module Dockerize

  describe Repository do
    let(:repository_hash) do
      JSON.parse(GithubHooks.repository_json)
    end

    subject do
      described_class.new(repository_hash)
    end

    its(:name)      { is_expected.to eq "lister/docker-hello-world" }
    its(:clone_url) { is_expected.to eq "spec/fixtures/docker-hello-world.git" }
  end

end
