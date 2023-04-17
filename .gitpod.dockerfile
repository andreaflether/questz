FROM gitpod/workspace-full
USER gitpod

# Install Ruby version 2.7.1 and set it as default
RUN echo "rvm_gems_path=/home/gitpod/.rvm" > ~/.rvmrc
RUN bash -lc "rvm install ruby-2.7.1 &&               rvm use ruby-ruby-2.7.1 --default"
RUN echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc