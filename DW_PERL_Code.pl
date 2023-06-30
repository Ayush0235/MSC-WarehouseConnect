#!/usr/bin/perl


# The below statements are called pragma and it can be placed at the beginning of the script.
# It forces you to code properly to make your program less error-prone. 
# For example: It forces you to declare variables before you use them. You can declare variable using “my” keyword.
# use strict;


# It helps you find typing mistakes, it warns you whenever it sees something wrong with your program.
# On the other hand use warnings would only provide you the warnings, it wont abort the execution.
use warnings;


# A hash is a set of key-value pairs. 
# Perl stores elements of a hash such that it searches for the values based on its keys.
my ( $cid, $name, $description, $weight, $source, $destination );


use DBI;
my $dsn = "DBI:mysql:cargo";
my $username = "ayush";
my $password = 'Ayush@2105';
my $dbh = DBI->connect($dsn,$username,$password) or 
            die("Error connecting to the database: $DBI::errstr\n");



# This is a sub routine to add cargo. 
sub add_cargo {

  print "Enter an unique cargo id: ";
  my $cid = <STDIN>;
  chomp($cid);

  my $key = $dbh->prepare("SELECT cid from cargo_table where cid = ?;");
  my $temp = $key->execute($cid);

  if($temp != 1) {

  	print "Enter the cargo name: ";
  	my $name = <STDIN>;
  	chomp($name);

  	print "Enter the cargo description: ";
  	$description = <>;
  	chomp($description);

  	print "Enter the cargo weight: ";
  	$weight = <>;
  	chomp($weight);

  	print "Enter the cargo source(location): ";
  	$source = <>;
  	chomp($source);

  	print "Enter the cargo destination(location): ";
  	$destination = <>;
  	chomp($destination);

  	my $sth = $dbh->prepare("INSERT INTO cargo_table values(?,?,?,?,?,?);");
  	$sth->execute($cid,$name,$description,$weight,$source,$destination);
  	print "\nCargo added successfully\n";

	}
   
   else {
	
	print "Cargo Id already exists";
	
	}

}



# This is a function to update cargo details.
sub update_cargo {
  
  print "Enter the cargo id to update cargo details: ";
  my $cid = <>;
  chomp($cid);

  my $key = $dbh->prepare("SELECT cid from cargo_table where cid = ?;");
  my $temp = $key->execute($cid);

  if($temp == 1) {

  my $choice=10;
  while($choice != 6) {
  
  print "1) Update Cargo Name\n";
  print "2) Update Cargo Description\n";
  print "3) Update Cargo Weight\n";
  print "4) Update Cargo Source\n";
  print "5) Update Cargo Destination\n";
  print "6) Exit\n\n";
  print "Enter your choice: ";
  
  $choice = <>;
  chomp($choice);
  
  use Switch;
  switch($choice) {

  case 1 { print "Enter the cargo name: ";
           my $name = <>;
           chomp($name);
           my $sth = $dbh->prepare("UPDATE cargo_table SET name = ? WHERE cid = ?");
           $sth->execute($name,$cid) or die $DBI::errstr;
           print "Cargo name updated successfully\n";
         }

  case 2 { print "Enter the cargo description: ";
           my $description = <>;
           chomp($description);
	   my $sth = $dbh->prepare("UPDATE cargo_table SET description = ? WHERE cid = ?");
	   $sth->execute($description,$cid) or die $DBI::errstr;
           print "Cargo description updated successfully\n";  
         }

  case 3 { print "Enter the cargo weight: ";
           my $weight = <>;
           chomp($weight);
	   my $sth = $dbh->prepare("UPDATE cargo_table SET weight = ? WHERE cid = ?");
           $sth->execute($weight,$cid) or die $DBI::errstr;
           print "Cargo weight updated successfully\n"; 
         }

  case 4 { print "Enter the cargo source: ";
           my $source = <>;
           chomp($source);
	   my $sth = $dbh->prepare("UPDATE cargo_table SET source = ? WHERE cid = ?");
           $sth->execute($source,$cid) or die $DBI::errstr;
           print "Cargo source updated successfully\n"; 
         }

  case 5 { print "Enter the cargo destination: ";
           my $destination = <>;
           chomp($destination);
           my $sth = $dbh->prepare("UPDATE cargo_table SET destination = ? WHERE cid = ?");
           $sth->execute($destination,$cid) or die $DBI::errstr;
	   print "Cargo destination updated successfully\n";
         }

  case 6 {
           print "Thank You for updating Cargo Management System\n";
           print "Exiting....................\n";
         }

  else	{ 
           print "Please enter a valid choice"; 
	}
      
      }
 
    }
  
  }

  else {

        print "Cargo Id does not exist";

       }

}



# This is a sub routine to delete a cargo.
sub delete_cargo {
  
  print "Enter the cargo id to delete: ";
  my $cid = <>;
  chomp($cid);

  my $key = $dbh->prepare("SELECT cid from cargo_table where cid = ?;");
  my $temp = $key->execute($cid);

  if($temp == 1) {

  my $sth = $dbh->prepare("DELETE FROM cargo_table WHERE cid = ?;");
  $sth->execute($cid);
  
  print "Cargo record with Id: $cid deleted successfully";
	}

  else {

        print "Cargo Id does not exist";

       }

}



# This is a function to display specific cargo details.
sub view_specific_cargo {
  
 print "Enter the cargo id for search: ";
 my $cid = <>;
 chomp($cid);

 my $key = $dbh->prepare("SELECT cid from cargo_table where cid = ?;");
 my $temp = $key->execute($cid);

 if($temp == 1) {

 my $sth = $dbh->prepare("SELECT * FROM cargo_table WHERE cid = ?;");
 $sth->execute($cid);
  
 while (my @row = $sth->fetchrow_array()) {

        my ($cid, $name, $description, $weight, $source, $destination) = @row;
        print "Cargo Id = $cid    Cargo Name = $name    Description = $description    Weight = $weight    Source = $source    Destination = $destination\n";

	}

	}
 
 else {

        print "Cargo Id does not exist";

      }

}



# This is a function to display all cargo details.
sub view_all_cargo {

  my $sth = $dbh->prepare("SELECT * from cargo_table;");
  $sth->execute();
  
  while (my @row = $sth->fetchrow_array()) {

  	my ($cid, $name, $description, $weight, $source, $destination) = @row;
  	print "Cargo Id = $cid    Cargo Name = $name    Description = $description    Weight =  $weight    Source = $source    Destination = $destination\n";

	}

}



# This is the main execution.
while (1) {

  print "\n\n";
  print "Welcome To Cargo Management System\n";
  print "1) Add Cargo\n";
  print "2) Update Cargo\n";
  print "3) Delete Cargo\n";
  print "4) View All Cargo Details\n";
  print "5) View Specific Cargo Details\n";
  print "6) Exit\n";
  print "Enter your choice: "; 
 
  my $choice = <>;
  chomp($choice);

  use Switch;
  switch($choice) {
  
  case 1 { add_cargo() }
  case 2 { update_cargo() }
  case 3 { delete_cargo() }
  case 4 { view_all_cargo() }
  case 5 { view_specific_cargo() }
  case 6 { 
	   print "Thank You for using Cargo Management System\n";
	   print "Exiting..................\n";
	   exit;
    }
  else { 
	   print "Please enter a valid choice";
       }

  }

}
