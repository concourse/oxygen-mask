describe 'a public pipeline', type: :feature do
  it 'can be viewed within 1 second' do
    visit dash_route("/teams/#{TEAM_NAME}/pipelines/#{PIPELINE_NAME}")
    expect(page).to have_content("simple-job", wait: 1)
  end
end
