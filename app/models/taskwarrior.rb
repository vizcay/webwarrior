require 'json'
require_relative 'task'
require_relative 'project'
require_relative 'tag'

class TaskWarrior
  def initialize
    @all_tasks    = []
    @all_projects = []
    @all_tags     = []
    import_data
  end

  def pending_tasks
    @all_tasks.select { |t| t.status == :pending }
  end

  def all_tasks
    @all_tasks
  end

  def completed_tasks
    @all_tasks.select { |t| t.status == :completed }
  end

  def projects
    @all_projects.select { |p| p.active? }
  end

  def tags
    @all_tags.select { |t| t.active? }
  end

  def find_project(project_name)
    @all_projects.find { |p| p.name == project_name }
  end

  def find_tag(tag_name)
    @all_tags.find { |t| t.name == tag_name }
  end

  def find_task_by_uuid(uuid)
    @all_tasks.find { |t| t.uuid == uuid }
  end

  def high_priority
    pending_tasks.select { |t| t.priority == 'H' }
  end

  def medium_priority
    pending_tasks.select { |t| t.priority == 'M' }
  end

  def low_priority
    pending_tasks.select { |t| t.priority == 'L' }
  end

  def import_data
    raw = JSON.parse("[#{`task export`}]")

    raw.map { |t| t['project'] }.uniq.each do |p|
      project = Project.new
      project.name = p
      @all_projects << project
    end
    @all_projects.sort_by! { |p| p.name }

    raw.map { |t| t['tags'] }.flatten.compact.uniq.each do |t|
      tag = Tag.new
      tag.name = t
      @all_tags << tag
    end
    @all_tags.sort_by! { |t| t.name }

    raw.each do |t|
      task = Task.new
      task.import_from_json(t)

      project = find_project(t['project'])
      task.project = project
      project.tasks << task

      t['tags'].each { |tag| find_tag(tag).tasks << task } if t['tags']

      @all_tasks << task
    end
    @all_tasks.sort_by! { |t| -t.urgency }
  end
end
