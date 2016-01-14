package ISWFModule
{
	import flash.system.ApplicationDomain;
	public interface IModule extends IClassFactory
	{
		function getApplicationDomain():ApplicationDomain;
	}
}