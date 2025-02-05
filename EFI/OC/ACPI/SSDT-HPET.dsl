//
// Supplementary HPET _CRS from Goldfish64
// Requires the HPET's _CRS to XCRS rename
//
DefinitionBlock ("", "SSDT", 2, "CORP", "HPET", 0x00000000)
{
    External (\HPET, DeviceObj)
    External (\HPET.XCRS, MethodObj)
    External (\HPET.XSTA, MethodObj)

    Scope (\HPET)
    {
        Name (BUFX, ResourceTemplate ()
        {
            IRQNoFlags ()
                {0,8,11}
            Memory32Fixed (ReadWrite,
                // Base/Length pulled from DSDT
                0xFED00000,         // Address Base
                0x00000400,         // Address Length
            )
        })
        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
        {
            // Return our buffer if booting macOS or the XCRS method
            // no longer exists for some reason
            If (LOr (_OSI ("Darwin"), LNot(CondRefOf (\HPET.XCRS))))
            {
                Return (BUFX)
            }
            // Not macOS and XCRS exists - return its result
            Return (\HPET.XCRS ())
        }
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            // Return 0x0F if booting macOS or the XSTA method
            // no longer exists for some reason
            If (LOr (_OSI ("Darwin"), LNot (CondRefOf (\HPET.XSTA))))
            {
                Return (0x0F)
            }
            // Not macOS and XSTA exists - return its result
            Return (\HPET.XSTA ())
        }
    }
}