# Effortlessly sandbox ANY REST API on local dev environment

That's the idea.

This is the CLI that connects to [Apidojo.com](https://apidojo.com) platform, allowing you to supercharge your personal/team productivity when you *design -> create -> consume -> test* REST APIs.

Quick overview: For any API provider that defines [API endpoints on the platform](https://apidojo.com/api), you will be able to call local URLs in accordance with the [sandboxing rules](https://apidojo.com/sandboxes) you [set up for the CLI](https://apidojo.com/cli).

## Why?

For a couple of reasons and common sense out of years of distilled experience dealing with APIs.

Check that out in the [Foundation articles](https://apidojo.com/articles/foundation)

## How

1. **Register in the platform** first, [choose your plan](https://apidojo.com/#pricing-content) - there's a 7 and 14 days FREE trials offered depending on the plan you opt, no credit card or payment required.
2. **Watch the 8 minutes demo video** to understand the basic principles
3. **Define yourself a few API endpoints** and a **sandbox** to play with
4. **Install the CLI** and play!

## CLI installation

The CLI is a ruby application, requiring a Ruby language runtime installed. **We recommend using RVM for all the following**.

### Prerequisites

1. **Install RVM**

The official RVM installation guide can be found at https://rvm.io/rvm/install

Chances are that if you read these lines, you already have all things required on your machine to quickly have it up and running with these 2 lines

`gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB` (might be deprecated, check the site for up to date keys)

then

 `\curl -sSL https://get.rvm.io | bash -s -- --autolibs=enable` 

2. **Grab Ruby**

`rvm install ruby-3.2.2 --autolibs=enable`

then check with

`ruby --version`

3. **Clone the CLI**

`git clone git@github.com:ApidojoHQ/Apidojo-CLI.git` then `cd` into it.

RVM at this point will automatically create a gemset for you. [Details here](https://rvm.io/gemsets/basics) if you want to know more about Gemsets.

Then finally type

`bundle install`

to load the libraries

### First handling

At this point you need to configure your CLI in order for it to be able to talk with the platform

1. Grab **USER TOKEN** from the platform [user profile](https://apidojo.com/settings/profile)
2. Create a `.env` file in the CLI directory, then write `APIDOJO_USER_TOKEN=your-user-token` in that file
3. Run `rvmsudo thor apidojo:sync` from the command line inside the CLI directory. That will pull API providers and sandbox settings from the platform. You MUST have defined these stuff in order to use the CLI.
4. Run `thor apidojo:start` to launch the CLI app with a command prompt, type `h` or `help` to know about the available commands.

From that moment when you launched a sandbox with the `sbx` or `sandbox` command, the CLI will spin off a local API server with local URLs (check your `/etc/hosts` file, the `sync` command in step 3 should have write entries there), that will allow you to call them and expect returns in accordance to the scenarios you defined in the platform.

That's it, happy API playing!

### Troubleshooting

Feel free to reach out in the platform built-in support, we will be happy to help.

For anything else, our email is always open [hey@apidojo.com](mailto:hey@apidojo.com)

## Licence

This CLI is released under the BSD 3-Clause License

Copyright (c), the respective contributors, as shown by the AUTHORS file.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
