# NAME

Ftree - family tree generator

# EXAMPLE 

[https://still-lowlands-7377.herokuapp.com](https://still-lowlands-7377.herokuapp.com)

# SYNOPSIS

installator for Windows 7 32bit
[https://sourceforge.net/projects/family-tree-32/files/latest/download?source=navbar](https://sourceforge.net/projects/family-tree-32/files/latest/download?source=navbar)

    #If install it
    cpanm https://cpan.metacpan.org/authors/id/M/MI/MISHIN/FamilyTreeInfo-2.3.16.tar.gz

    #copy the folder cgi-bin from the distribution
    cp cgi-bin c:\ftree\cgi-bin 
    
    #then got to it directory
    c:\ftree\cgi-bin
    #and run
    plackup -I..\lib
    
    #HTTP::Server::PSGI: Accepting connections at http://0:5000/

    #now go to the browser
    http://127.0.0.1:5000/

    #and we can see a family tree, and
    #to his Office just need to edit the file
    c:\ftree\cgi-bin\tree.xls
    
    #or the file with a different name, but then this name must indicate file 
    ftree.config
    #changing parameter
    file_name tree.xls
    #on your

    #and pictures of relatives should be 3 x 4
    #and they need to be put in the directory
    c:\ftree\cgi-bin\pictures
    #where the name of the picture must be a person id + .jpg
    #all works!

    #for Unix you will need to fix option

    photo_dir c:/ftree/cgi-bin/pictures/

    #on your

# NAME OF THE PICTURE:

One picture may belong to each person. The name of the picture file reflects the person it belongs to. The picture file is obtained from the lowercased full name by substituting spaces with underscores and adding the file extension to it. From example from "Ferenc Bodon3" we get "ferenc\_bodon3.jpg".

# PERFORMANCE ISSUES:

This sofware was not designed so that it can handle very large family trees. It can easily cope with few thousands of members, but latency (time till page is generated) grows as the size of the family tree increases.
The main bottleneck of performance is that (1.) mod\_perl is not used, therefore perl interpreter is starts for every request (2.) family tree is not cached but data file is parsed and tree is built-up for every request (using serialized format helps a little).
Since the purpose of this software is to provide a free and simple tool for those who would like to maintain their family tree themself, performance is not the primary concern.

# SECURITY ISSUES:

The protection provided by password request (set in config file) is quite primitive, i.e. it is easy to break it.
Ther are historical reasons for being available. We suggest to use server side protection like .htaccess files in case of apache web servers. 

# AUTHORS

Dr. Ferenc Bodon and Simon Ward and Nikolay Mishin
http://www.cs.bme.hu/~bodon/en/index.html
http://simonward.com

# MAINTAINER

Nikolay Mishin

# COPYRIGHT

Copyright 2015- Dr. Ferenc Bodon and Simon Ward and Nikolay Mishin

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# ACKNOWLEDGEMENTS

I am in debt to the translators:
Csaba Kiss (French)
Gergely Kovacs (German),
Przemek Swiderski (Polish),
Rober Miles (Italian),
Lajos Malozsak (Romanian),
Vladimir Kangin (Russian)

I also would like to thank the feedback/help of (in no particular order) Alex Roitman, Anthony Fletcher, 
Richard Bos, Sylvia McKenzie and Sean Symes.

# SEE ALSO
