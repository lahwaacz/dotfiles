# test if the config is loaded
#print("Hello, world!  I'm a .latexmkrc\n");

# enable synctex
$pdflatex = 'pdflatex -shell-escape -synctex=1 %O %S';

# disable viewer autolaunch
$pdf_previewer = '';
$pdf_update_method = 0;

# custom rule for SageTex
# ref: https://bitbucket.org/ddrake/sagetex/wiki/UsingSageTeX
#add_cus_dep('sage', 'sout', 0, 'makesout');
#$hash_calc_ignore_pattern{'sage'} = '^( _st_.goboom|print .SageT)';
#sub makesout {
#    system("cd \$(dirname '$_[0]'); sage \$(basename '$_[0].sage')");
#}
