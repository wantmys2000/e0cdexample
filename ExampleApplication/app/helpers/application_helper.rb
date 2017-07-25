module ApplicationHelper
  def code_version
    if File.exists?("version.txt")
      File.read("version.txt")
    else
      "development"
    end
  end
end
