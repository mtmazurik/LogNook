namespace CCA.Services.LogNook.Config
{
    public interface IJsonConfiguration
    {
        string ConnectionString { get; }
        double TaskManagerIntervalSeconds { get; }
        string JwtSecretKey { get; }
        string JwtIssuer { get; }
        bool EnforceTokenLife { get; }
    }
}