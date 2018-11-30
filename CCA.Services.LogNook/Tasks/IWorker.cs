using System.Threading;
using System.Threading.Tasks;

namespace CCA.Services.LogNook.Tasks
{
    public interface IWorker
    {
        Task DoTheTask();
    }
}