#! /bin/bash
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

# Copy all files to public
# Markdown files never interfered with
cp -r markdown/* public/

# Convert header.md footer.md
if [ -f public/header.md ]; then
    
    cat public/header.md | pandoc -f markdown -t html > public/header.html
    rm public/header.md
fi
if [ -f public/footer.md ]; then
    cat public/footer.md | pandoc -f markdown -t html > public/footer.html
    rm public/footer.md
fi

# Convert all other markdown
for file in $(find public/ -name '*.md')
do
    # Extract file path
    f=${file%.md}
    #filename=${temp#*/}
    
    
    echo $file
    
    # Put styles in
    styles='<link rel="stylesheet" href="/css/normalize.css">
            <link rel="stylesheet" href="/css/header.css">
            <link rel="stylesheet" href="/css/style.css">
            <link rel="stylesheet" href="/css/footer.css">' 
    
    echo "$styles" > $f.html

    # Put header into each html file
    if [ -f public/header.html ]; then
        echo '<header>' >> $f.html
        cat public/header.html >> $f.html
        echo '</header>' >> $f.html
    else
        cat '' > $f.html  # Start with blank file
    fi

    echo '<main>' >> $f.html
    cat $file | pandoc -f markdown -t html >> $f.html
    echo '</main>' >> $f.html

    # Put footer into each html file
    if [ -f public/footer.html ]; then
        echo '<footer>' >> $f.html
        cat public/footer.html >> $f.html
        echo '</footer>' >> $f.html
    fi


   # Make valid html
    tidy -im $f.html 2> /dev/null

    # Remove markdown
    rm $file
done

echo "done"
