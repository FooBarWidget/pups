class Pups::Command

  def self.run(command,params)
    case command
      when String then self.from_str(command,params).run
      when Hash then self.from_hash(command,params).run
    end
  end


  def interpolate_params(cmd)
    Pups::Config.interpolate_params(cmd,@params)
  end
end
