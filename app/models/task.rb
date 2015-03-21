require 'time'

class Task
  attr_accessor :id, :uuid, :description, :project, :status, :priority, :entry, :due, :urgency, :tags

  def import_from_json(task)
    @id          = task['id']
    @uuid        = task['uuid']
    @description = task['description']
    @status      = task['status'].to_sym
    @priority    = task['priority']
    @entry       = Date.iso8601(task['entry'])
    @due         = Date.iso8601(task['due']) if task['due']
    @urgency     = task['urgency'].to_f
    @tags        = task['tags']
  end

  def complete!
    system "task #{@id} done"
  end
end
