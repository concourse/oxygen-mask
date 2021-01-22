require 'spec_helper'

describe 'build history', type: :feature do
  include Fly

  before(:each) do
    fly_login
  end

  it 'can be viewed within 1 second' do
    builds = fly_table("builds -j #{PIPELINE_NAME}/simple-job")
    build_number = builds[1]["build"]
    visit dash_route("/teams/#{TEAM_NAME}/pipelines/#{PIPELINE_NAME}/jobs/simple-job/builds/#{build_number}")
    expect(page).to have_content("say-hello", wait: 1)
  end
end
