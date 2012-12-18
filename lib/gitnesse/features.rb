module Gitnesse
  class Features

    # Public: Writes a feature to disk, given the filename and the
    # features.
    #
    # filename - the filename to use for the feature
    # features - the features to write to disk
    #
    def self.write_file(filename, features)
      File.open(filename, "w") do |file|
        file.write(gather(features))
      end
    end

    # Public: Gathers features for placing into files. Currently only supports
    # one feature per page. Others are discarded
    #
    # page_features - the features
    #
    # Returns a string containing the
    def self.gather(page_features)
      return '' if page_features.nil? || page_features.empty?

      features = ''

      name, content = page_features.shift
      puts "  \e[32m\e[1mPulling Feature: \e[0m#{name}"
      features += content

      page_features.each do |name, feature|
        puts "  \e[33m\e[1mDiscarding Feature: \e[0m#{name}"
      end

      features
    end
  end
end
