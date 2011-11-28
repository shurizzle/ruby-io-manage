#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class IO
  def suppress
    _, old = IO.pipe
    old.reopen(self)
    _.close
    self.reopen(IO.pipe.last)

    yield
  ensure
    self.reopen(old)
    old.close
  end

  def catch
    _, old = IO.pipe
    old.reopen(self)
    _.close
    pip = IO.pipe

    begin
      self.reopen(pip.last)
      yield
    ensure
      pip[1].close
      self.reopen(old)
      old.close
    end

    pip[0].read
  ensure
    pip[0].close
  end
end
