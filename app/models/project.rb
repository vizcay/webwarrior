class Project
  attr_accessor :name, :tasks, :subprojects

  def initialize
    @tasks       = []
    @subprojects = []
  end

  def pending_tasks
    all_tasks.select { |t| t.status == :pending }.sort_by { |t| -t.urgency }
  end

  def active?
    not pending_tasks.empty?
  end

  def all_tasks
    @subprojects.inject(@tasks) { |all_tasks, subproject| all_tasks += subproject.tasks }
  end
end
