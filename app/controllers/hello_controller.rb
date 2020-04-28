class HelloController < ApplicationController
  def hello
  end
  
  def index
    @message = 'Hello!'
    @extra = 'I am the hello controller!'
    @count = 2
  end
end
