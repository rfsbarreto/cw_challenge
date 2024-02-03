# Use an official Ruby runtime as a parent image
FROM ruby:3.2.2

# Install nodejs and postgresql-client
RUN apt-get update -qq && apt-get install -y postgresql-client

# Set the working directory in the container to /myapp
WORKDIR /myapp

# Add `/myapp/bin` to $PATH
ENV PATH /myapp/bin:$PATH

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Install any needed packages specified in Gemfile
RUN bundle install

# Copy the current directory contents into the container at /myapp
COPY . /myapp

# Expose port 3000 to the outside world
EXPOSE 3000

# The main command to run when the container starts. Also tell the Rails dev server to bind to all interfaces by default.
CMD ["rails", "server", "-b", "0.0.0.0"]

