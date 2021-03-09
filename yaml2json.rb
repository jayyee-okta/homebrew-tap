# Copyright 2015-2017 Ryan McKern

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##########
#
# install by running `brew install yaml2json.rb --HEAD`
#
##########

require "language/go"

class Yaml2json < Formula
  desc "command line tool convert from yaml to json"
  homepage "https://github.com/bronze1man/yaml2json"
  head "https://github.com/bronze1man/yaml2json.git"

  depends_on "go" => :build

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "v2.2.1"
  end

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/bronze1man/yaml2json").install contents

    ENV["GOPATH"] = gopath

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/bronze1man/yaml2json" do
    system "go", "build", "-o", "yaml2json"
      bin.install "yaml2json"
    end
  end

  test do
    assert_equal %({"key":"cat"}), pipe_output("#{bin}/yaml2json", "key: cat", 0).chomp
  end
end
