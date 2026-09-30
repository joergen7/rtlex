pragma Warnings (Off);
with Ada.Assertions; use Ada.Assertions;
--  Make Assert visible to children
pragma Warnings (On);

pragma Ignore_Pragma (Alire_Test);
--  Alire configures tests through this pragma. This clause silences warnings
--  by GNAT about it. The pragma has no impact on GNAT compilation.

package Rtlex_Tests is

end Rtlex_Tests;
