class HelloController < ApplicationController
  def index
    @message = 'Hello!'
    @extra = 'I am the hello controller!'
    @count = 2
  end
end
