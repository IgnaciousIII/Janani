using Microsoft.AspNetCore.Mvc;
using Npgsql;
using System.Threading.Tasks;

[Route("api/[controller]")]
[ApiController]
public class PwRegistrationController : ControllerBase
{
    private readonly string _connString = "Host=localhost;Database=maternal_health;Username=postgres;Password=1224";

    [HttpGet("{rchid}")]
    public async Task<IActionResult> GetByRchId(long rchid)
    {
        using var conn = new NpgsqlConnection(_connString);
        await conn.OpenAsync();

        var cmd = new NpgsqlCommand("SELECT * FROM pw_registration WHERE rchid = @rchid", conn);
        cmd.Parameters.AddWithValue("rchid", rchid);

        using var reader = await cmd.ExecuteReaderAsync();
        if (!reader.HasRows)
            return NotFound("No record found for the given rchid.");

        await reader.ReadAsync();

        // Map fields to a DTO or anonymous object
        var result = new
        {
            RchId = reader.GetInt64(reader.GetOrdinal("rchid")),
            Sno = reader.GetInt32(reader.GetOrdinal("sno")),
            District = reader.GetString(reader.GetOrdinal("district")),
            HealthBlock = reader.GetString(reader.GetOrdinal("health_block")),
            HealthFacility = reader.GetString(reader.GetOrdinal("health_facility")),
            HealthSubFacility = reader.GetString(reader.GetOrdinal("health_subfacility")),
            Village = reader.GetString(reader.GetOrdinal("village")),
            CaseNo = reader.GetInt32(reader.GetOrdinal("caseno")),
            MotherName = reader.GetString(reader.GetOrdinal("mothername")),
            MotherAge = reader.GetInt32(reader.GetOrdinal("motherage")),
            HusbandName = reader.GetString(reader.GetOrdinal("husbandname")),
            RegistrationDate = reader.IsDBNull(reader.GetOrdinal("registrationdate")) ? (DateTime?)null : reader.GetDateTime(reader.GetOrdinal("registrationdate")),
            Lmp = reader.IsDBNull(reader.GetOrdinal("lmp")) ? (DateTime?)null : reader.GetDateTime(reader.GetOrdinal("lmp")),
            // ... continue for all relevant fields you want to expose
            hb = reader.GetDouble(reader.GetOrdinal("hb")),
            gluc = reader.GetInt32(reader.GetOrdinal("gluc")),
            pulse = reader.GetInt32(reader.GetOrdinal("pulse")),
            spo2 = reader.GetInt32(reader.GetOrdinal("spo2")),
            fhr = reader.GetInt32(reader.GetOrdinal("fhr")),
        };

        return Ok(result);
    }

    [HttpGet("all-mothers-last-visit")]
    public async Task<IActionResult> GetAllMothersWithLastVisit()
    {
        using var conn = new NpgsqlConnection(_connString);
        await conn.OpenAsync();

        var cmd = new NpgsqlCommand(@"
            SELECT 
                sno, rchid, mothername, mobileno, motherage, edd,
                COALESCE(
                    GREATEST(
                        anc1, anc2, anc3, anc4, registrationdate
                    ), registrationdate
                ) AS lastvisit
            FROM pw_registration
            WHERE mothername IS NOT NULL
            ORDER BY lastvisit DESC;", conn);

        var reader = await cmd.ExecuteReaderAsync();

        var resultList = new List<object>();
        while (await reader.ReadAsync())
        {
            resultList.Add(new
            {
                Sno = reader.GetInt32(reader.GetOrdinal("sno")),
                RchId = reader.GetInt64(reader.GetOrdinal("rchid")),
                Name = reader.GetString(reader.GetOrdinal("mothername")),
                Phone = reader.IsDBNull(reader.GetOrdinal("mobileno")) ? "" : reader.GetString(reader.GetOrdinal("mobileno")),
                Age = reader.IsDBNull(reader.GetOrdinal("motherage")) ? 0 : reader.GetInt32(reader.GetOrdinal("motherage")),
                LastAppointment = reader.IsDBNull(reader.GetOrdinal("lastVisit")) ? (DateTime?)null : reader.GetDateTime(reader.GetOrdinal("lastVisit")),
                dueDate = reader.IsDBNull(reader.GetOrdinal("edd")) ? (DateTime?)null : reader.GetDateTime(reader.GetOrdinal("edd"))
            });
        }

        return Ok(resultList);
    }
}


