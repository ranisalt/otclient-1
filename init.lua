-- this is the first file executed when the application starts
-- we have to load the first modules form here
-- set true so that modules are reloaded when modified. (Note: Use only dev mod)
AUTO_RELOAD_MODULE = false

-- WALKING SYSTEM
-- Set true if using Nostalrius 7.2, Nekiro TFS-1.5-Downgrades-7.72
-- or any protocol below 860 that the walking system is stuttering.
g_game.setForceNewWalkingFormula(true)

-- set latest supported version
g_game.setLastSupportedVersion(1291)

-- setup logger
g_logger.setLogFile(g_resources.getWorkDir() .. g_app.getCompactName() .. '.log')
g_logger.info(os.date('== application started at %b %d %Y %X'))

-- print first terminal message
g_logger.info(g_app.getName() .. ' ' .. g_app.getVersion() .. ' rev ' .. g_app.getBuildRevision() .. ' (' ..
                  g_app.getBuildCommit() .. ') built on ' .. g_app.getBuildDate() .. ' for arch ' ..
                  g_app.getBuildArch())

-- add data directory to the search path
if not g_resources.addSearchPath(g_resources.getWorkDir() .. 'data', true) then
    g_logger.fatal('Unable to add data directory to the search path.')
end

-- add modules directory to the search path
if not g_resources.addSearchPath(g_resources.getWorkDir() .. 'modules', true) then
    g_logger.fatal('Unable to add modules directory to the search path.')
end

-- try to add mods path too
g_resources.addSearchPath(g_resources.getWorkDir() .. 'mods', true)

-- setup directory for saving configurations
g_resources.setupUserWriteDir(('%s/'):format(g_app.getCompactName()))

-- search all packages
g_resources.searchAndAddPackages('/', '.otpkg', true)

-- load settings
g_configs.loadSettings('/config.otml')

g_modules.discoverModules()

-- libraries modules 0-99
g_modules.autoLoadModules(99)
g_modules.ensureModuleLoaded('corelib')
g_modules.ensureModuleLoaded('gamelib')

-- client modules 100-499
g_modules.autoLoadModules(499)
g_modules.ensureModuleLoaded('client')

-- game modules 500-999
g_modules.autoLoadModules(999)
g_modules.ensureModuleLoaded('game_interface')

-- mods 1000-9999
g_modules.autoLoadModules(9999)

local script = '/' .. g_app.getCompactName() .. 'rc.lua'

if g_resources.fileExists(script) then
    dofile(script)
end
