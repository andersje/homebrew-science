
require 'formula'

class Qualimap < Formula

  homepage 'http://qualimap.bioinfo.cipf.es/'
  url 'http://qualimap.bioinfo.cipf.es/release/qualimap_v0.7.1.zip'
  sha1 '65be770802797998fa1a96fb3c12558b8b741052'
  def install
    chmod 0755, 'qualimap'
    prefix.install Dir['*']
    mkdir_p bin
    mkdir_p lib
    bin.install(prefix/'qualimap')
    cp prefix/'qualimap.jar', lib/'qualimap.jar'
  end

  def patches
    # fixes path setup for java libs and qualimap bin
    DATA
  end

  def test
    system "qualimap", "-h"
  end
end
__END__
--- a/qualimap	2013-04-19 14:07:42.000000000 -0500
+++ b/qualimap	2013-09-12 11:00:20.813917000 -0500
@@ -49,35 +49,17 @@
 
 prg=$0
 
-# check if symbolic link
-
-while [ -h "$prg" ] ; do
-    ls=`ls -ld "$prg"`
-    link=`expr "$ls" : '.*-> \(.*\)$'`
-    if expr "$link" : '.*/.*' > /dev/null; then
-        prg="$link"
-    else
-        prg="`dirname $prg`/$link"
-    fi
-done
-
-
 shell_path=`dirname "$prg"`;
-absolute=`echo $shell_path | grep "^/"`;
 
-if [ -z $absolute ]
-then
-	export QUALIMAP_HOME="`pwd`/$shell_path"
-else 
-	export QUALIMAP_HOME="$shell_path"
-fi
+## disabled some of the clever path detection because it 
+## was too clever by half, and didn't work with brew
 
-# For debug purposes
+export QUALIMAP_HOME="$shell_path"
 
-#echo $QUALIMAP_HOME
-#echo "ARGS are ${ARGS[@]}"
+export BREWDIR=$(echo $QUALIMAP_HOME | sed -e 's/bin$//g')
+export CLASSPATH="$BREWDIR/bin/qualimap.jar:$BREWDIR/lib/*:$BREWDIR/Cellar/qualimap/*/lib/*"
 
-java $java_options -classpath $QUALIMAP_HOME/qualimap.jar:$QUALIMAP_HOME/lib/* org.bioinfo.ngs.qc.qualimap.main.NgsSmartMain "${ARGS[@]}"
+java $java_options -classpath $CLASSPATH org.bioinfo.ngs.qc.qualimap.main.NgsSmartMain "${ARGS[@]}"
 
 if [ -n "$OUTPUT_ADDITIONAL_HELP" ]; then 
     echo "Special arguments: "
