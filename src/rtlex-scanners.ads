with Ada.Strings.Unbounded;
with Ada.Containers.Indefinite_Ordered_Maps;
with GNAT.Regpat;

use type GNAT.Regpat.Pattern_Matcher;
use type GNAT.Regpat.Match_Location;

generic
   type Token_Category is (<>);
   Eof_Cat   : Token_Category;
   Error_Cat : Token_Category;
package Rtlex.Scanners
is

   type Token is private;

   function Is_Eof
     (Tk : Token)
     return Boolean;

   function Is_Error
     (Tk : Token)
     return Boolean;

   function Get_Cat
     (Tk : Token)
     return Token_Category;

   function Get_First
     (Tk : Token)
     return Positive;

   function Get_Last
     (Tk : Token)
     return Natural;

   function Length
     (Tk : Token)
     return Natural;

   function Make_Token
     (Cat   : Token_Category;
      First : Positive := 1;
      Last  : Natural  := 0)
     return Token;

   ------------------------------------------------------------

   type Scanner is tagged private;

   procedure Add_Pattern
     (Sc      : in out Scanner;
      Cat     :        Token_Category;
      Pattern :        String);

   procedure Set_Input
     (Sc    : in out Scanner;
      Input :        String);

   procedure Next
     (Sc : in out Scanner;
      Tk :    out Token);

   function Get_Text
     (Sc : Scanner;
      Tk : Token)
     return String;

   function Null_Scanner
     return Scanner;

private

   type Token is
      record
         Cat   : Token_Category;
         First : Positive;
         Last  : Natural;
      end record;

   package Maps is new Ada.Containers.Indefinite_Ordered_Maps
     (Key_Type     => Token_Category,
      Element_Type => GNAT.Regpat.Pattern_Matcher);

   type Scanner is tagged
      record
         Input       : Ada.Strings.Unbounded.Unbounded_String;
         Idx         : Positive;
         Pattern_Map : Maps.Map;
      end record;

end Rtlex.Scanners;
