require 'spec_helper'

describe "as a customer" do
  let!(:client)  { create_client }
  let!(:project) { create_project(client) }

  it "creates an issue" do
    summary     = Faker::Lorem.sentence(1)
    description = Faker::Lorem.paragraph(2)

    issue = client.issues.create(
      :project     => project,
      :summary     => summary,
      :description => description,
    )

    expect(issue.project).to     eq(project)
    expect(issue.id).to          match(project.identity)
    expect(issue.summary).to     eq(summary)
    expect(issue.description).to eq(description)
  end

  context "with an issue" do

    let!(:issue) {
      client.issues.create(project: project, summary: Faker::Lorem.sentence(1), description: Faker::Lorem.paragraph(2))
    }

    it "gets an issue" do
      expect(client.issues.get(issue.identity)).to eq(issue)
    end

    it "lists issues" do
      expect(client.issues.all(project)).to include(issue)
    end

    it "lists no issues to prove that the parser is sane" do
      expect(client.issues.all(project, {"after" => 100})).to be_empty
    end

    it "updates an issue" do
      new_summary       = Faker::Lorem.sentence(1)
      new_description   = Faker::Lorem.paragraph(2)
      issue.summary     = new_summary
      issue.description = new_description

      issue.save

      expect(issue.reload.summary).to eq(new_summary)
      expect(issue.reload.description).to eq(new_description)
    end

    it "changes the issue state" do
      states = ['Open', 'Deployed']

      new_state = states.find { |s| s != issue.state }

      expect {
        issue.state = new_state
      }.to change { issue.state }.to(new_state)
    end
  end
end
