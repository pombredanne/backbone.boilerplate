# Backbone Boilerplate

This boilerplate is generated via backbone-amd generator in [yeoman](http://yeoman.io). I have made some minor updates:

- Add JST support
- Add [backbone.layoutmanager](http://documentup.com/tbranyen/backbone.layoutmanager/)
- Fix bug to support coffeescript build distribution


# Installation

```bash
# Install yeoman, bower and grunt-cli
npm install -g yo grunt-cli bower coffee-script

# Clone to local disk
mkdir myproj && cd $_
git clone https://github.com/xiaocong/backbone.boilerplate.git .

# Install bower and node packages
bower install
npm install
```

# Development

```bash
# Start development server
grunt server

# Start distribution server
grunt server:dist

# Distribution
grunt build

# Test
grunt test
```
