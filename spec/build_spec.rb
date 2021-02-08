describe 'build history', type: :feature do
  include Fly

  before(:each) do
    fly_login
  end

  it 'can be viewed within 1 second' do
    builds = fly_table("builds -j #{PIPELINE_NAME}/simple-job")
    build_id = builds[1]["id"]
    visit dash_route("/builds/#{build_id}")
    expect(page).to have_content("say-hello", wait: 1)
  end
end
