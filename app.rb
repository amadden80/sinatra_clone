require_relative "lib/application"
require 'pry'

class HelloWorld < Application
  get '/' do
    @instructors = Instructor.all
    render :index
  end

  post '/instructors' do
    Instructor.create(params)
    redirect '/'
  end

  delete '/instructors/:id' do
    Instructor.delete(params[:id])
    redirect '/'
  end

end







