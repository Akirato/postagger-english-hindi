
echo "Testing Installation"
echo "--------------------"
echo "--------------------"
shallow_parser_hin < tests/shallowparser_hin_utf.rin > /tmp/out.tes
diff tests/shallowparser_hin_utf.rout /tmp/out.tes > /tmp/output.tmp
if [[ -s /tmp/output.tmp ]] ; then
echo "Installation Unsuccessful Please Check the INSTALLATION Properly"
echo "Report to shallowparser@research.iiit.ac.in";
else
echo "Shallow Parser for Hindi version 4.0 installed successfully."
echo "See README-user to see how to run the shallow parser."
fi ;
