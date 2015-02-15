class Project
  attr_accessor :name, :tasks

  def initialize
    @tasks = []
  end

  def pending_tasks
    tasks.select { |t| t.status == :pending }.sort_by { |t| -t.urgency }
  end

  def active?
    not pending_tasks.empty?
  end
end
