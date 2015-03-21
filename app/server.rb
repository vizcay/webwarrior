require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'uri'

require_relative 'models/taskwarrior'

set :port, 4488
also_reload 'app/models/taskwarrior.rb'
also_reload 'app/models/task.rb'
also_reload 'app/models/project.rb'

get '/' do
  @tw              = TaskWarrior.new
  @tasks           = @tw.pending_tasks
  @page_title      = 'pending tasks'
  @selected_filter = :pending_tasks
  haml :index
end

get '/all' do
  @tw              = TaskWarrior.new
  @tasks           = @tw.all_tasks
  @page_title      = 'all tasks'
  @selected_filter = :all_tasks
  haml :index
end

get '/completed' do
  @tw              = TaskWarrior.new
  @tasks           = @tw.completed_tasks
  @page_title      = 'completed tasks'
  @selected_filter = :completed_tasks
  haml :index
end

get '/tag/:tag' do
  @tw           = TaskWarrior.new
  @tasks        = @tw.find_tag(params[:tag]).pending_tasks
  @selected_tag = params[:tag]
  @page_title   = "#{params[:tag]} tag"
  haml :index
end

get '/project/:project' do
  @tw               = TaskWarrior.new
  @tasks            = @tw.find_project(params[:project]).pending_tasks
  @selected_project = params[:project]
  @page_title       = "#{params[:project]} project"
  haml :index
end

get '/priority/:priority' do
  @tw = TaskWarrior.new
  case params[:priority]
  when 'H'
    @tasks             = @tw.high_priority
    @page_title        = 'high priority'
    @selected_priority = :high
  when 'M'
    @tasks             = @tw.medium_priority
    @page_title        = 'medium priority'
    @selected_priority = :medium
  when 'L'
    @tasks             = @tw.low_priority
    @page_title        = 'low priority'
    @selected_priority = :low
  end
  haml :index
end

get '/task/:uuid/done' do
  tw = TaskWarrior.new
  task = tw.find_task_by_uuid(params[:uuid])
  task.complete!
  redirect to("/project/#{task.project.name}")
end
