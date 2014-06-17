class Arcana < ActiveRecord::Base

  attr_reader :job_code

  def job_code
    "#{self.job_type}#{self.job_index}"
  end

  def sirialize
    j = self.attributes
    j['job_code'] = job_code
    j
  end

end
