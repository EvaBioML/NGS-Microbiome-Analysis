conda activate lefse
#��ʽվ�
txtname="name.txt"
filename="name"
filepath="/path/${filename}/"
group1="A"
group2="B"
total="2"

cd "${filepath}"

lefse_format_input.py "${filepath}${txtname}" lefse.in -c 1 -u 1 -o 100000
lefse_run.py lefse.in lefse.res -l 2.0
lefse_plot_res.py --dpi 300 lefse.res lefse.png

cd ..
#�i�H����
#lefse_plot_cladogram.py lefse.res lefse.cladogram.png --format png
