require 'open3'
require 'shellwords'

module Fly
  class FlyError < RuntimeError; end

  def fly(command)
    run "fly -t #{TARGET} #{command}"
  end

  def fly_login
    fly("login -k -c #{ATC_URL} -n #{TEAM_NAME} -u #{Shellwords.shellescape(USERNAME)} -p #{Shellwords.shellescape(PASSWORD)}")
  end

  def fly_fail(command)
    run "fly -t #{TARGET} #{command}"
  rescue FlyError
    nil
  else
    raise "expected '#{command}' to not succeed"
  end

  def fly_table(command)
    output, _ = run "fly --print-table-headers -t #{TARGET} #{command}"

    rows = []
    headers = nil
    output.each_line do |line|
      cols = line.strip.split(/\s{2,}/)

      if headers
        row = {}
        headers.each.with_index do |key, i|
          row[key] = cols[i]
        end

        rows << row
      else
        headers = cols
      end
    end

    rows
  end

  def fly_with_input(command, input)
    run "echo '#{input}' | fly -t #{TARGET} #{command}"
  end

  private

  def run(command)
    stdout, stderr, status = Open3.capture3 command

    raise FlyError, "'#{command}' failed (status #{status.exitstatus}):\n\n#{output}" \
      unless status.success?

    [stdout, stderr]
  end
end
