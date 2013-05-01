## Jay Emerson
## September 2, 2012

## First, download the new version of the Boost Libraries and
## set the variables boostall and version, here:

#boostall <- 'boost_1_51_0.tar.gz'
#version <- '1.51.0-0'

boostall <- 'boost_1_43_0.tar.gz'
version <- '1.43.0-0'

date <- '2013-01-29'
pkgdir <-  paste(getwd(), '/', 'pkg/BH', sep="")          # No trailing slash

boostroot <- paste(getwd(), '/', gsub('.tar.gz', '', boostall), sep="")

## Next, move the old BoostHeaders package aside for safety, and
## I'll do a sanity check here before continuing:

if (!file.exists(boostall) && !file.exists(boostroot)) {
  stop('That Boost input does not exist')
}
if (file.exists(pkgdir)) {
#  cat("svn rm pkg/BH\n")
#  cat("svn commit\n")
#  cat("Then when this is done and tested, add it back into the svn\n")

  cat("rm -rf pkg/BH\n")
#  cat("Then when this is done and tested, add it back into the svn\n")
stop('Move aside the old BH')
}


########################################################################
# Unpack, copy from boost to BoostHeaders/inst/include,
# and build the supporting infrastructure of the package.

if (!file.exists(boostroot)) {
  system(paste('tar -zxf', boostall))
}

system(paste('mkdir', pkgdir))
system(paste('mkdir ', pkgdir, '/inst', sep=""))
system(paste('mkdir ', pkgdir, '/man', sep=""))
system(paste('mkdir ', pkgdir, '/src', sep=""))
system(paste('mkdir ', pkgdir, '/inst/include', sep=""))


# bcp --scan --boost=boost_1_51_0 ../bigmemory/pkg/bigmemory/src/*.cpp test

system('rm -f bcp.log')

# The bigmemory Boost dependencies:
system(paste('bcp --scan --boost=', boostroot,
             ' ../bigmemory/pkg/bigmemory/src/*.cpp ',
             pkgdir, '/inst/include >> bcp.log', sep=''))
system(paste('bcp --scan --boost=', boostroot,
             ' ../bigmemory/pkg/synchronicity/src/*.cpp ',
             pkgdir, '/inst/include >> bcp.log', sep=''))

# Plus filesystem
system(paste('bcp --boost=', boostroot,
             ' filesystem ',
             pkgdir, '/inst/include >> bcp.log', sep=''))

system(paste('bcp --boost=', boostroot,
             ' iostreams ',
             pkgdir, '/inst/include >> bcp.log', sep=''))

system(paste('bcp --boost=', boostroot,
             ' system ',
             pkgdir, '/inst/include >> bcp.log', sep=''))

system(paste('bcp --boost=', boostroot,
             ' regex ',
             pkgdir, '/inst/include >> bcp.log', sep=''))

system(paste('bcp --scan --boost=', boostroot,
             ' /vol/R/BioC/devel-29/mzR/src/pwiz/data/msdata/MSData.hpp ',
             pkgdir, '/inst/include >> bcp.log', sep=''))
system(paste('bcp --scan --boost=', boostroot,
             ' /vol/R/BioC/devel-29/mzR/src/pwiz/utility/misc/Container.hpp ',
             pkgdir, '/inst/include >> bcp.log', sep=''))
system(paste('bcp --scan --boost=', boostroot,
             ' /vol/R/BioC/devel-29/mzR/src/pwiz/utility/minimxml/XMLWriter.cpp ',
             pkgdir, '/inst/include >> bcp.log', sep=''))

system(paste('( cd /vol/R/BioC/devel-29/mzR/src/ ; ',
             'bcp --scan --boost=', boostroot,
             ' /vol/R/BioC/devel-29/mzR/src/pwiz/utility/misc/Std.hpp ',
             pkgdir, '/inst/include ) >> bcp.log', sep=''))

system  (paste('find /vol/R/BioC/devel-29/mzR/src/pwiz -type f ',
             '-exec bcp --scan --boost=', boostroot,
            ' {}  ', 
             pkgdir, '/inst/include \\; >> bcp.log ', sep=''))

system  (paste('find /vol/R/BioC/devel-29/mzR/src/boost_aux -type f ',
             '-exec bcp --scan --boost=', boostroot,
            ' {}  ', 
             pkgdir, '/inst/include \\; >> bcp.log ', sep=''))

#system(paste('/bin/rm -rf ', pkgdir, '/inst/include/libs', sep=''))
system(paste('/bin/rm -rf ', pkgdir, '/inst/include/Jamroot', sep=''))
system(paste('/bin/rm -rf ', pkgdir, '/inst/include/boost.png', sep=''))
system(paste('/bin/rm -rf ', pkgdir, '/inst/include/doc', sep=''))

system(paste('cp BoostHeadersROOT/DESCRIPTION', pkgdir))
system(paste('cp BoostHeadersROOT/LICENSE*', pkgdir))
system(paste('cp BoostHeadersROOT/NAMESPACE', pkgdir))
system(paste('cp -p BoostHeadersROOT/man/*.Rd ', pkgdir, '/man', sep=''))
system(paste('cp -p BoostHeadersROOT/src/Makevars ', pkgdir, '/src', sep=''))

system(paste('sed -i "s/XXX/', version, '/g" ', pkgdir, '/DESCRIPTION',
             sep=""))
system(paste('sed -i "s/YYY/', date, '/g" ', pkgdir, '/DESCRIPTION',
             sep=""))
system(paste('sed -i "s/XXX/', version,
             '/g" ', pkgdir, '/man/BH-package.Rd', sep=""))
system(paste('sed -i "s/YYY/', date,
             '/g" ', pkgdir, '/man/BH-package.Rd', sep=""))

cat("\n\nNow svn add pkg/BH\n")
cat("and svn commit\n")

#########################################################################
# Now fix up things that don't work, if necessary.  Here, we need to stay
# organized and decide who is the maintainer of what, but this script
# is the master record of any changes made to the boost tree.

## bigmemory et.al. will require changes to support Windows; we
## believe the Mac and Linux versions will be fine without changes.

## We'll invite co-maintainers who identify changes needed to support
## their specific libraries.



