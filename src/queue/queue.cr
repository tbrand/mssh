module Mssh
  class Queue
    enum Status
      NotReady
      Enqueued
      Fin
    end

    @@queue : Queue? = nil

    def self.init(parallel : Int32)
      @@queue = Queue.new(parallel)
    end

    def self.global : Queue
      raise "queue is not ready" unless queue = @@queue
      queue
    end

    @status  : Status = Status::NotReady
    @running : Int32 = 0
    @queue   : Array(Executable) = [] of Executable

    def initialize(@parallel : Int32)
    end

    def <<(executable : Executable)
      enqueue(executable)
    end

    def enqueue(executable : Executable)
      @queue << executable

      check
    end

    def handle
      @running -= 1

      check
    end

    def check
      if !dequeue? && @queue.empty? && @running == 0 && @status == Status::Enqueued
        L.info "finished every jobs 😎"

        @status = Status::Fin
      end
    end

    def dequeue? : Bool
      return false if @queue.empty?
      return false if @running >= @parallel

      @running += 1

      spawn @queue.shift.exec

      true
    end

    def wait
      @status = Status::Enqueued

      loop do
        sleep 0.1
        break if @status == Status::Fin
      end
    end
  end
end
