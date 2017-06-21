# Use an official base image
FROM ruby:2.3-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD ./OCCI4IOT /app

# Install any needed packages
RUN bundle install

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV SINK 172.17.0.1

# Run app.py when the container launches
CMD ["ruby", "manager.rb"]
