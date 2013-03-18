function archive_gom(year,mon)

yeardmon = [year,'-',mon];
BASE = '/home/thesser1/GOM/model/';
BASEA = '/mnt/CHL_WIS_1/GOM/Evaluation/WW3/';
arcf = [BASEA,'/Figures/',yeardmon];
out = [BASE,'/',yeardmon];
arcm = [BASEA,'/Model/',yeardmon];
if ~exist(arcm,'dir')
    mkdir(arcm);
end

if ~exist(arcf,'dir')
    mkdir(arcf);
end

loc{1} = 'LEVEL1';
loc{2} = 'LEVEL2';
loc{3} = 'LEVEL3W';
loc{4} = 'LEVEL3C1';
loc{5} = 'LEVEL3C2';
loc{6} = 'LEVEL3E';

for zz = 1:6
    val = [out,'/',loc{zz},'/Validation/'];
    arcv = [BASEA,'/Validation/WIS/',yeardmon,'/',loc{zz},'/'];
    arcfl = [arcf,'/',loc{zz},'/'];
    arcml = [arcm,'/',loc{zz},'/'];
    if ~exist(arcv,'dir')
        mkdir(arcv);
    end
    if ~exist(arcfl,'dir')
        mkdir(arcfl);
    end
    if ~exist(arcml,'dir')
        mkdir(arcml);
    end
    system(['cp ',out,'/',loc{zz},'/*.tgz ',arcml]);
    system(['cp ',out,'/',loc{zz},'/*.png ',arcfl]);
    system(['cp ',val,'/* ',arcv]);
end