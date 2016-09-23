require 'rails_helper'

RSpec.describe Task, type: :model do
  subject { build :task }

  it "calls #set_max_priority before create" do
    expect(subject).to receive(:set_max_priority)
    subject.save
    subject.text = 'another text'
    subject.save
  end

  describe '#set_max_priority' do
    let(:project) { create :project }

    context 'when no tasks in project' do
      let(:task) { create(:task, project: project) }
      it "sets priority to 1" do
        expect(task.priority).to eq(1)
      end
    end # when no tasks in project

    context 'when project has tasks' do
      let(:tasks) { 4.times.map{ create(:task, project: project) } }
      before do
        tasks[0].update(priority: 20)
        tasks[1].update(priority: 30)
        tasks[2].update(priority: 15)
        tasks[3].update(priority: 1)
      end
      it "sets priority to max + 1" do
        new_task = create(:task, project: project)
        expect(new_task.priority).to eq(31)
      end
    end # when project has tasks

    context 'when exists 2 projects with tasks' do
      let(:project2) { create :project }
      let(:tasks) { 4.times.map{ create(:task, project: project) } }
      let(:tasks2) { 2.times.map{ create(:task, project: project2) } }
      before do
        tasks[0].update(priority: 20)
        tasks[1].update(priority: 30)
        tasks[2].update(priority: 15)
        tasks[3].update(priority: 1)
        tasks2[0].update(priority: 35)
        tasks2[1].update(priority: 10)
      end
      it "sets priority to max + 1" do
        new_task = create(:task, project: project)
        expect(new_task.priority).to eq(31)
      end
    end # when exists 2 projects with tasks
  end # #set_max_priority


  shared_context 'tasks with priority' do
    let(:project1) { create :project }
    let(:project2) { create :project }
    let(:tasks1) { 4.times.map{ create(:task, project: project1) } }
    let(:tasks2) { 4.times.map{ create(:task, project: project2) } }
    before (:each) do
      tasks1[0].priority = tasks2[0].priority = 10
      tasks1[1].priority = tasks2[1].priority = 20
      tasks1[2].priority = tasks2[2].priority = 30
      tasks1[3].priority = tasks2[3].priority = 40
      tasks1.each &:save!
      tasks2.each &:save!
    end
  end

  describe '#up_priority' do
    include_context 'tasks with priority'

    context 'when task does not have max priority' do
      it 'changes priorities in tasks array' do
        tasks1[1].up_priority
        tasks1.each &:reload
        expect(tasks1[0].priority).to eq 10
        expect(tasks1[1].priority).to eq 30
        expect(tasks1[2].priority).to eq 20
        expect(tasks1[3].priority).to eq 40
      end
      it "returns true" do
        expect(tasks1[1].up_priority).to eq true
      end
    end # when task does not have max priority

    context 'when task has max priority' do
      it 'does not change priorities in tasks array' do
        tasks1[3].up_priority
        tasks1.each &:reload
        expect(tasks1[0].priority).to eq 10
        expect(tasks1[1].priority).to eq 20
        expect(tasks1[2].priority).to eq 30
        expect(tasks1[3].priority).to eq 40
      end
      it "returns false" do
        expect(tasks1[3].up_priority).to eq false
      end
    end # when task has max priority

  end # #up_priority

  describe '#down_priority' do
    include_context 'tasks with priority'

    context 'when task does not have max priority' do
      it 'changes priorities in tasks array' do
        tasks1[1].down_priority
        tasks1.each &:reload
        expect(tasks1[0].priority).to eq 20
        expect(tasks1[1].priority).to eq 10
        expect(tasks1[2].priority).to eq 30
        expect(tasks1[3].priority).to eq 40
      end
      it "returns true" do
        expect(tasks1[1].down_priority).to eq true
      end
    end # when task does not have max priority

    context 'when task has max priority' do
      it 'does not change priorities in tasks array' do
        tasks1[0].down_priority
        tasks1.each &:reload
        expect(tasks1[0].priority).to eq 10
        expect(tasks1[1].priority).to eq 20
        expect(tasks1[2].priority).to eq 30
        expect(tasks1[3].priority).to eq 40
      end
      it "returns false" do
        expect(tasks1[0].down_priority).to eq false
      end
    end # when task has max priority

  end # #down_priority

end
