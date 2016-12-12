module GithubHooks
  module_function

  def pusher_json
    '{
      "name": "lister",
      "email": "simon@lisuna.org"
    }'
  end

  def repository_json
    '{
      "full_name": "lister/docker-hello-world",
      "clone_url": "spec/fixtures/docker-hello-world.git"
    }'
  end

  def master_lister
    '{
      "ref": "refs/heads/master",
      "before": "171b622dd365fbc889917cb17ad2b10de38c72a7",
      "after": "cd696048d6bc4f83317361c50fa87059dfef928f",
      "created": false,
      "deleted": false,
      "forced": false,
      "base_ref": null,
      "compare": "https://github.com/lister/stairlightsrb/compare/171b622dd365...cd696048d6bc",
      "commits": [
        {
          "id": "cd696048d6bc4f83317361c50fa87059dfef928f",
          "tree_id": "7af34fc5a70d5cb463d7116771fcdf5daaae7db5",
          "distinct": true,
          "message": "firetest.",
          "timestamp": "2016-10-09T13:11:31+02:00",
          "url": "https://github.com/lister/stairlightsrb/commit/cd696048d6bc4f83317361c50fa87059dfef928f",
          "author": {
            "name": "lister",
            "email": "simon@lisuna.org",
            "username": "lister"
          },
          "committer": {
            "name": "lister",
            "email": "simon@lisuna.org",
            "username": "lister"
          },
          "added": [

          ],
          "removed": [

          ],
          "modified": [
            "celluloid.rb"
          ]
        }
      ],
      "head_commit": {
        "id": "cd696048d6bc4f83317361c50fa87059dfef928f",
        "tree_id": "7af34fc5a70d5cb463d7116771fcdf5daaae7db5",
        "distinct": true,
        "message": "firetest.",
        "timestamp": "2016-10-09T13:11:31+02:00",
        "url": "https://github.com/lister/stairlightsrb/commit/cd696048d6bc4f83317361c50fa87059dfef928f",
        "author": {
          "name": "lister",
          "email": "simon@lisuna.org",
          "username": "lister"
        },
        "committer": {
          "name": "lister",
          "email": "simon@lisuna.org",
          "username": "lister"
        },
        "added": [

        ],
        "removed": [

        ],
        "modified": [
          "celluloid.rb"
        ]
      },
      "repository": {
        "id": 58662418,
        "name": "stairlightsrb",
        "full_name": "lister/stairlightsrb",
        "owner": {
          "name": "lister",
          "email": "simon@lisuna.org"
        },
        "private": false,
        "html_url": "https://github.com/lister/stairlightsrb",
        "description": "",
        "fork": false,
        "url": "https://github.com/lister/stairlightsrb",
        "forks_url": "https://api.github.com/repos/lister/stairlightsrb/forks",
        "keys_url": "https://api.github.com/repos/lister/stairlightsrb/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/lister/stairlightsrb/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/lister/stairlightsrb/teams",
        "hooks_url": "https://api.github.com/repos/lister/stairlightsrb/hooks",
        "issue_events_url": "https://api.github.com/repos/lister/stairlightsrb/issues/events{/number}",
        "events_url": "https://api.github.com/repos/lister/stairlightsrb/events",
        "assignees_url": "https://api.github.com/repos/lister/stairlightsrb/assignees{/user}",
        "branches_url": "https://api.github.com/repos/lister/stairlightsrb/branches{/branch}",
        "tags_url": "https://api.github.com/repos/lister/stairlightsrb/tags",
        "blobs_url": "https://api.github.com/repos/lister/stairlightsrb/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/lister/stairlightsrb/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/lister/stairlightsrb/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/lister/stairlightsrb/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/lister/stairlightsrb/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/lister/stairlightsrb/languages",
        "stargazers_url": "https://api.github.com/repos/lister/stairlightsrb/stargazers",
        "contributors_url": "https://api.github.com/repos/lister/stairlightsrb/contributors",
        "subscribers_url": "https://api.github.com/repos/lister/stairlightsrb/subscribers",
        "subscription_url": "https://api.github.com/repos/lister/stairlightsrb/subscription",
        "commits_url": "https://api.github.com/repos/lister/stairlightsrb/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/lister/stairlightsrb/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/lister/stairlightsrb/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/lister/stairlightsrb/issues/comments{/number}",
        "contents_url": "https://api.github.com/repos/lister/stairlightsrb/contents/{+path}",
        "compare_url": "https://api.github.com/repos/lister/stairlightsrb/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/lister/stairlightsrb/merges",
        "archive_url": "https://api.github.com/repos/lister/stairlightsrb/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/lister/stairlightsrb/downloads",
        "issues_url": "https://api.github.com/repos/lister/stairlightsrb/issues{/number}",
        "pulls_url": "https://api.github.com/repos/lister/stairlightsrb/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/lister/stairlightsrb/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/lister/stairlightsrb/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/lister/stairlightsrb/labels{/name}",
        "releases_url": "https://api.github.com/repos/lister/stairlightsrb/releases{/id}",
        "deployments_url": "https://api.github.com/repos/lister/stairlightsrb/deployments",
        "created_at": 1463073989,
        "updated_at": "2016-05-12T17:28:39Z",
        "pushed_at": 1476011496,
        "git_url": "git://github.com/lister/stairlightsrb.git",
        "ssh_url": "git@github.com:lister/stairlightsrb.git",
        "clone_url": "https://github.com/lister/stairlightsrb.git",
        "svn_url": "https://github.com/lister/stairlightsrb",
        "homepage": null,
        "size": 27,
        "stargazers_count": 0,
        "watchers_count": 0,
        "language": "Ruby",
        "has_issues": true,
        "has_downloads": true,
        "has_wiki": true,
        "has_pages": false,
        "forks_count": 0,
        "mirror_url": null,
        "open_issues_count": 0,
        "forks": 0,
        "open_issues": 0,
        "watchers": 0,
        "default_branch": "master",
        "stargazers": 0,
        "master_branch": "master"
      },
      "pusher": {
        "name": "lister",
        "email": "simon@lisuna.org"
      },
      "sender": {
        "login": "lister",
        "id": 126756,
        "avatar_url": "https://avatars.githubusercontent.com/u/126756?v=3",
        "gravatar_id": "",
        "url": "https://api.github.com/users/lister",
        "html_url": "https://github.com/lister",
        "followers_url": "https://api.github.com/users/lister/followers",
        "following_url": "https://api.github.com/users/lister/following{/other_user}",
        "gists_url": "https://api.github.com/users/lister/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/lister/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/lister/subscriptions",
        "organizations_url": "https://api.github.com/users/lister/orgs",
        "repos_url": "https://api.github.com/users/lister/repos",
        "events_url": "https://api.github.com/users/lister/events{/privacy}",
        "received_events_url": "https://api.github.com/users/lister/received_events",
        "type": "User",
        "site_admin": false
      }
    }'


  end
end
