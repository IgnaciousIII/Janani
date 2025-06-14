using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using Npgsql;
using System.Globalization;

public class IndexModel : PageModel
{
    [BindProperty]
    public IFormFile excelFile { get; set; }

    public void OnGet() { }

    public async Task<IActionResult> OnPostAsync()
    {
        if (excelFile == null || excelFile.Length == 0)
        {
            ViewData["Message"] = "Please select a valid Excel file.";
            return Page();
        }

        try
        {
            using var stream = excelFile.OpenReadStream();
            IWorkbook workbook = new XSSFWorkbook(stream);
            var sheet = workbook.GetSheet("Sheet2") ?? workbook.GetSheetAt(0);

            var connString = "Host=localhost;Database=maternal_health;Username=postgres;Password=1224";
            using var conn = new NpgsqlConnection(connString);
            await conn.OpenAsync();

            for (int i = 1; i <= sheet.LastRowNum; i++)
            {
                var row = sheet.GetRow(i);
                if (row == null) continue;

                var rchidCell = row.GetCell(6);
                if (rchidCell == null || string.IsNullOrWhiteSpace(rchidCell.ToString()))
                    continue;

                var rchid = Convert.ToInt64(rchidCell.ToString());
                
                // Existing fields
                var sno = GetIntCell(row, 0);
                var district = GetStringCell(row, 1);
                var healthBlock = GetStringCell(row, 2);
                var healthFacility = GetStringCell(row, 3);
                var healthSubFacility = GetStringCell(row, 4);
                var village = GetStringCell(row, 5);
                var caseNo = GetIntCell(row, 7);
                var motherName = GetStringCell(row, 8);
                var husbandName = GetStringCell(row, 9);
                var mobileof = GetStringCell(row, 10);
                var mobileNo = GetStringCell(row, 11);
                var motherAge = GetIntCell(row, 12);
                var bankName = GetStringCell(row, 13);
                var address = GetStringCell(row, 14);
                var anmName = GetStringCell(row, 15);
                var ashaName = GetStringCell(row, 16);
                var registrationDate = GetDateCell(row, 17);
                var lmp = GetDateCell(row, 18);
                var medPastIllness = GetStringCell(row, 19);
                var edd = GetDateCell(row, 20);

                // New fields
                var anc1 = GetDateCell(row, 21);
                var anc2 = GetDateCell(row, 22);
                var anc3 = GetDateCell(row, 23);
                var anc4 = GetDateCell(row, 24);
                var tt1 = GetDateCell(row, 25);
                var tt2 = GetDateCell(row, 26);
                var ttb = GetDateCell(row, 27);
                var anc_ifa = GetStringCell(row, 28);
                var pnc_ifa = GetStringCell(row, 29);
                var ifa = GetStringCell(row, 30);
                var delivery = GetStringCell(row, 31);
                var pnc1 = GetStringCell(row, 32);
                var pnc2 = GetStringCell(row, 33);
                var pnc3 = GetStringCell(row, 34);
                var pnc4 = GetStringCell(row, 35);
                var pnc5 = GetStringCell(row, 36);
                var pnc6 = GetStringCell(row, 37);
                var pnc7 = GetStringCell(row, 38);
                var highRisk1stVisit = GetStringCell(row, 39);
                var highRisk2ndVisit = GetStringCell(row, 40);
                var highRisk3rdVisit = GetStringCell(row, 41);
                var highRisk4thVisit = GetStringCell(row, 42);
                var hbLevel1stVisit = GetDoubleCell(row, 43);
                var hbLevel2ndVisit = GetDoubleCell(row, 44);
                var hbLevel3rdVisit = GetDoubleCell(row, 45);
                var hbLevel4thVisit = GetDoubleCell(row, 46);
                var maternalDeath = GetStringCell(row, 47);
                var abortionPresent = GetStringCell(row, 48);
                var jsyBeneficiary = GetStringCell(row, 49);
                var deathDate = GetDateCell(row, 50);
                var deathReason = GetStringCell(row, 51);
                var hb = GetDoubleCell(row,52);
                var pulse = GetIntCell(row,53);
                var spo2 = GetIntCell(row,54);
                var gluc = GetIntCell(row,55);
                var fhr = GetIntCell(row,56);

                var cmd = new NpgsqlCommand(@"
                    INSERT INTO pw_registration (
                        rchid, sno, district, health_block, health_facility, health_subfacility, village, caseno, 
                        mothername, husbandname, mobileof, mobileno, motherage, bankname, address, anm_name, asha_name, 
                        registrationdate, lmp, med_pastillness, edd, anc1, anc2, anc3, anc4, tt1, tt2, ttb, anc_ifa, 
                        pnc_ifa, ifa, delivery, pnc1, pnc2, pnc3, pnc4, pnc5, pnc6, pnc7, highrisk1stvisit, 
                        highrisk2ndvisit, highrisk3rdvisit, highrisk4thvisit, hblevel1stvisit, hblevel2ndvisit, 
                        hblevel3rdvisit, hblevel4thvisit, maternaldeath, abortion_present, jsy_beneficiary, 
                        death_date, death_reason,hb, pulse, spo2, gluc,fhr
                    ) VALUES (
                        @rchid, @sno, @district, @health_block, @health_facility, @health_subfacility, @village, @caseNo, 
                        @mothername, @husbandname, @mobileof, @mobileno, @motherage, @bankname, @address, @anm_name, 
                        @asha_name, @registrationdate, @lmp, @med_pastillness, @edd, @anc1, @anc2, @anc3, @anc4, 
                        @tt1, @tt2, @ttb, @anc_ifa, @pnc_ifa, @ifa, @delivery, @pnc1, @pnc2, @pnc3, @pnc4, @pnc5, 
                        @pnc6, @pnc7, @highrisk1stvisit, @highrisk2ndvisit, @highrisk3rdvisit, @highrisk4thvisit, 
                        @hblevel1stvisit, @hblevel2ndvisit, @hblevel3rdvisit, @hblevel4thvisit, @maternaldeath, 
                        @abortion_present, @jsy_beneficiary, @death_date, @death_reason,@hb,@pulse,@spo2,@gluc,@fhr
                    )
                    ON CONFLICT (rchid) DO UPDATE SET
                        sno = EXCLUDED.sno,
                        district = EXCLUDED.district,
                        health_block = EXCLUDED.health_block,
                        health_facility = EXCLUDED.health_facility,
                        health_subfacility = EXCLUDED.health_subfacility,
                        village = EXCLUDED.village,
                        caseNo = EXCLUDED.caseno,
                        mothername = EXCLUDED.mothername,
                        husbandname = EXCLUDED.husbandname,
                        mobileof = EXCLUDED.mobileof,
                        mobileno = EXCLUDED.mobileno,
                        motherage = EXCLUDED.motherage,
                        bankname = EXCLUDED.bankname,
                        address = EXCLUDED.address,
                        anm_name = EXCLUDED.anm_name,
                        asha_name = EXCLUDED.asha_name,
                        registrationdate = EXCLUDED.registrationdate,
                        lmp = EXCLUDED.lmp,
                        med_pastillness = EXCLUDED.med_pastillness,
                        edd = EXCLUDED.edd,
                        anc1 = EXCLUDED.anc1,
                        anc2 = EXCLUDED.anc2,
                        anc3 = EXCLUDED.anc3,
                        anc4 = EXCLUDED.anc4,
                        tt1 = EXCLUDED.tt1,
                        tt2 = EXCLUDED.tt2,
                        ttb = EXCLUDED.ttb,
                        anc_ifa = EXCLUDED.anc_ifa,
                        pnc_ifa = EXCLUDED.pnc_ifa,
                        ifa = EXCLUDED.ifa,
                        delivery = EXCLUDED.delivery,
                        pnc1 = EXCLUDED.pnc1,
                        pnc2 = EXCLUDED.pnc2,
                        pnc3 = EXCLUDED.pnc3,
                        pnc4 = EXCLUDED.pnc4,
                        pnc5 = EXCLUDED.pnc5,
                        pnc6 = EXCLUDED.pnc6,
                        pnc7 = EXCLUDED.pnc7,
                        highrisk1stvisit = EXCLUDED.highrisk1stvisit,
                        highrisk2ndvisit = EXCLUDED.highrisk2ndvisit,
                        highrisk3rdvisit = EXCLUDED.highrisk3rdvisit,
                        highrisk4thvisit = EXCLUDED.highrisk4thvisit,
                        hblevel1stvisit = EXCLUDED.hblevel1stvisit,
                        hblevel2ndvisit = EXCLUDED.hblevel2ndvisit,
                        hblevel3rdvisit = EXCLUDED.hblevel3rdvisit,
                        hblevel4thvisit = EXCLUDED.hblevel4thvisit,
                        maternaldeath = EXCLUDED.maternaldeath,
                        abortion_present = EXCLUDED.abortion_present,
                        jsy_beneficiary = EXCLUDED.jsy_beneficiary,
                        death_date = EXCLUDED.death_date,
                        death_reason = EXCLUDED.death_reason,
                        hb = EXCLUDED.hb,
                        pulse = EXCLUDED.pulse,
                        spo2 = EXCLUDED.spo2,
                        gluc = EXCLUDED.gluc,
                        fhr = EXCLUDED.fhr
                ", conn);

                // Existing parameters
                cmd.Parameters.AddWithValue("rchid", rchid);
                cmd.Parameters.AddWithValue("sno", sno);
                cmd.Parameters.AddWithValue("district", district);
                cmd.Parameters.AddWithValue("health_block", healthBlock);
                cmd.Parameters.AddWithValue("health_facility", healthFacility);
                cmd.Parameters.AddWithValue("health_subfacility", healthSubFacility);
                cmd.Parameters.AddWithValue("village", village);
                cmd.Parameters.AddWithValue("caseno", caseNo);
                cmd.Parameters.AddWithValue("mothername", motherName);
                cmd.Parameters.AddWithValue("husbandname", husbandName);
                cmd.Parameters.AddWithValue("mobileof", mobileof);
                cmd.Parameters.AddWithValue("mobileno", mobileNo);
                cmd.Parameters.AddWithValue("motherage", motherAge);
                cmd.Parameters.AddWithValue("bankname", bankName);
                cmd.Parameters.AddWithValue("address", address);
                cmd.Parameters.AddWithValue("anm_name", anmName);
                cmd.Parameters.AddWithValue("asha_name", ashaName);
                cmd.Parameters.AddWithValue("registrationdate", registrationDate ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("lmp", lmp ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("med_pastillness", medPastIllness);
                cmd.Parameters.AddWithValue("edd", edd ?? (object)DBNull.Value);

                // New parameters
                cmd.Parameters.AddWithValue("anc1", anc1 ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("anc2", anc2 ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("anc3", anc3 ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("anc4", anc4 ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("tt1", tt1 ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("tt2", tt2 ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("ttb", ttb ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("anc_ifa", anc_ifa);
                cmd.Parameters.AddWithValue("pnc_ifa", pnc_ifa);
                cmd.Parameters.AddWithValue("ifa", ifa);
                cmd.Parameters.AddWithValue("delivery", delivery);
                cmd.Parameters.AddWithValue("pnc1", pnc1);
                cmd.Parameters.AddWithValue("pnc2", pnc2);
                cmd.Parameters.AddWithValue("pnc3", pnc3);
                cmd.Parameters.AddWithValue("pnc4", pnc4);
                cmd.Parameters.AddWithValue("pnc5", pnc5);
                cmd.Parameters.AddWithValue("pnc6", pnc6);
                cmd.Parameters.AddWithValue("pnc7", pnc7);
                cmd.Parameters.AddWithValue("highrisk1stvisit", highRisk1stVisit);
                cmd.Parameters.AddWithValue("highrisk2ndvisit", highRisk2ndVisit);
                cmd.Parameters.AddWithValue("highrisk3rdvisit", highRisk3rdVisit);
                cmd.Parameters.AddWithValue("highrisk4thvisit", highRisk4thVisit);
                cmd.Parameters.AddWithValue("hblevel1stvisit", hbLevel1stVisit);
                cmd.Parameters.AddWithValue("hblevel2ndvisit", hbLevel2ndVisit);
                cmd.Parameters.AddWithValue("hblevel3rdvisit", hbLevel3rdVisit);
                cmd.Parameters.AddWithValue("hblevel4thvisit", hbLevel4thVisit);
                cmd.Parameters.AddWithValue("maternaldeath", maternalDeath);
                cmd.Parameters.AddWithValue("abortion_present", abortionPresent);
                cmd.Parameters.AddWithValue("jsy_beneficiary", jsyBeneficiary);
                cmd.Parameters.AddWithValue("death_date", deathDate ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("death_reason", deathReason);
                cmd.Parameters.AddWithValue("hb", hb);
                cmd.Parameters.AddWithValue("pulse", pulse);
                cmd.Parameters.AddWithValue("spo2", spo2);
                cmd.Parameters.AddWithValue("gluc", gluc);
                cmd.Parameters.AddWithValue("fhr", fhr);
                await cmd.ExecuteNonQueryAsync();
            }

            ViewData["Message"] = "Excel data imported successfully!";
        }
        catch (Exception ex)
        {
            ViewData["Message"] = $"Error: {ex.Message}";
        }

        return Page();
    }

    // Helper methods
    private string GetStringCell(IRow row, int idx) => row.GetCell(idx)?.ToString()?.Trim() ?? "";
    
    private int GetIntCell(IRow row, int idx)
    {
        var cell = row.GetCell(idx);
        if (cell == null) return 0;
        return cell.CellType == CellType.Numeric ? (int)cell.NumericCellValue : 
            int.TryParse(cell.ToString(), out int result) ? result : 0;
    }
    
    private double GetDoubleCell(IRow row, int idx)
    {
        var cell = row.GetCell(idx);
        if (cell == null) return 0;
        return cell.CellType == CellType.Numeric ? cell.NumericCellValue : 
            double.TryParse(cell.ToString(), out double result) ? result : 0;
    }
    
    private DateTime? GetDateCell(IRow row, int idx)
    {
        var cell = row.GetCell(idx);
        if (cell == null) return null;
        
        if (cell.CellType == CellType.Numeric && DateUtil.IsCellDateFormatted(cell))
            return cell.DateCellValue;
            
        if (DateTime.TryParseExact(cell.ToString(), 
            new[] { "dd/MM/yyyy", "d/M/yyyy", "yyyy-MM-dd" }, 
            CultureInfo.InvariantCulture, DateTimeStyles.None, out var date))
            return date;
            
        return null;
    }
}
