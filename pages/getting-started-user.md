---
layout: page-fullwidth
permalink: "/getting-started-user/"
header:
  title: "Getting Started : Users"
  subheadline: "How to use CODE-RADE"
  image_fullwidth: "header_roadmap_2.jpg"
show_meta: true
---

# CODE-RADE delivers pre-built, tested applications to you.

Applications are built for various target architectures, so you have to be using one of these. Basically, this comes down to having either a RedHat 6 clone, or an Ubuntu-14.04 platform. For other targets, go ahead and try, YMMV.

# Before you start

Using CODE-RADE requires :

  - A machine corresponding to one of the target architectures
  - Access to the network[^Initial]
    - A local cache on your machine will be used - the required size depends on which applications you use. CVMFS will only stage the files you need.
  - AutoFS client on your machine
  - [CVMFS](http://cernvm.cern.ch/portal/filesystem/) on your machine
    - [Download](http://cernvm.cern.ch/portal/filesystem/downloads#cvmfs) the packages relevant for your system
    - Run the [Ansible](http://www.ansible.com) [playbook](https://github.com/AAROC/DevOps/blob/master/Ansible/cvmfs.yml) in the [DevOps repository](http://github.com/AAROC/DevOps)
    - **You will need to have local priveliges to do this**
  - Environment Modules

See the [CVMFS documentation](http://cernvm.cern.ch/portal/filesystem/techinformation) for installing CMVFS.

# Mount the repositories

You will need to update your local configuration to access the CODE-RADE repositories. See [the AfricaGrid page](http://www.africa-grid.org/cvmfs/) for more information of how to do this.

# Set up your shell

CODE-RADE provides environment modules in order to make using the applications easier. Add the following lines[^bash]

{% highlight bash %}
#modules
. /etc/profile.d/modules.sh
# cvmfs stuff
export SITE=generic
export OS=u1404
export ARCH=x86_64
export CVMFS_DIR=/cvmfs/fastrepo.sagrid.ac.za/

# Add modules
module use $CVMFS_DIR/modules/compilers
module use $CVMFS_DIR/modules/libraries
#  other sections can be added such as astro, bioinformatics, etc
{% endhighlight %}

# Add and go.

Once you've added the modules to your environment, you can find out what's available and start using applications; they will be cached locally. A good sanity check is to see what build version you're using. If you've used the standard mount point, look at the <code>version</code> file :

{% highlight bash %}
cat ${CVMFS_DIR}/version
Build 119
{% endhighlight %}

For example you can now add a new compiler to your evironment :

{% highlight bash %}
$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/5/lto-wrapper
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 5.2.1-22ubuntu2' --with-bugurl=file:///usr/share/doc/gcc-5/README.Bugs --enable-languages=c,ada,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-5 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-vtable-verify --enable-libmpx --enable-plugin --with-system-zlib --disable-browser-plugin --enable-java-awt=gtk --enable-gtk-cairo --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-5-amd64/jre --enable-java-home --with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-5-amd64 --with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-5-amd64 --with-arch-directory=amd64 --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --enable-objc-gc --enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2)

module add gcc/5.1.0
$ gcc -vbelow
COLLECT_LTO_WRAPPER=/cvmfs/fastrepo.sagrid.ac.za/generic/u1404/x86_64/gcc/5.1.0/libexec/gcc/x86_64-unknown-linux-gnu/5.1.0/lto-wrapper
Target: x86_64-unknown-linux-gnu
Configured with: ../configure --prefix=/cvmfs/fastrepo.sagrid.ac.za/generic/u1404/x86_64/gcc/5.1.0 --with-ncurses= --with-mpfr=/cvmfs/fastrepo.sagrid.ac.za/generic/u1404/x86_64/mpfr/3.1.2 --with-mpc=/cvmfs/fastrepo.sagrid.ac.za/generic/u1404/x86_64/mpc/1.0.1 --with-gmp=/cvmfs/fastrepo.sagrid.ac.za/generic/u1404/x86_64/gmp/5.1.3 --enable-languages=c,c++,fortran,java --disable-multilib
Thread model: posix
gcc version 5.1.0 (GCC)
{% endhighlight %}

You, my friend, are now ready to rock !
<div class="text-center">
<video id="gif-mp4" poster="https://media.giphy.com/media/V2Ylf5EhsUPMQ/200_s.gif" style="margin:0;padding:0" autoplay="" loop="" height="176" width="420">
            <source src="https://media.giphy.com/media/V2Ylf5EhsUPMQ/giphy.mp4" type="video/mp4">
            Your browser does not support the mp4 video codec.
</video>
</div>
[^Initial]: At least initially.
[^bash]: These are for bash. If you use a different shell, change as necessary.
