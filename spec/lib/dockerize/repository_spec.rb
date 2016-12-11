require 'spec_helper'

module Dockerize

  describe Repository do
    let(:repository_hash) do
      JSON.parse(GithubHooks.repository_json)
    end

    subject do
      described_class.new(repository_hash)
    end

    its(:name)      { is_expected.to eq "lister/stairlightsrb" }
    its(:clone_url) { is_expected.to eq "https://github.com/lister/stairlightsrb.git" }
  end

end
