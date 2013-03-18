function long_term_stats_PAC(yearmon1,yearmon2)
clf;close all
basin = 'Pacific';model = 'WW3 ST4';
yearmon1c = num2str(yearmon1);
year1 = yearmon1c(1:4);mon1 = yearmon1c(5:6);
yearmon2c = num2str(yearmon2);
year2 = yearmon2c(1:4);mon2 = yearmon2c(5:6);
gridc = '';
tit1 = [basin,' Basin Longterm Analysis'];
tit2 = ['Model = ',model];
tit3 = ['Grid = Pac-1 deg'];%,gridc];
tit4 = ['Time = ',year1,' - ',year2];
tit = {tit1;tit2;tit3;tit4};
mloc = 'C:\matlab\My_Matlab\Wis_plot\PAC\';
outdir = ['X:\Pacific\Production\Longterm\'];
if ~exist(outdir,'dir');
    mkdir(outdir);
end
lev = gridc(6:end);
load([mloc,'PAC','-plot.mat']);
load([mloc,'PAC-buoy.mat']);
stype = {'bx-';'ro-';'g+-';'k*-.';'md-';'cs-'};
itype = {'Bias';'RMSE';'SI'};
btype = {'H_{s} (m)';'WS (m/s)';'T_{m} (s)'};
units = {'(m)';'(m/s)';'(s)'};
bb = 0;
fields1 = {'wvhtme';'wspdme';'tmmme'};
fields2 = {'wvhtst';'wndsst';'tmmst'};
type = {'wvht','wspd','tmm'};
yeard = [str2num(year1):1:str2num(year2)];
toll = [-1,0,0;-2,0,0;-2,0,0];tolh = [1,1,60;2,4,60;2,4,60];
idty = [4,2,6];
for jj = 1:size(compend,1)
    nn = 0;
    if compend(jj,1) == 99999
       continue
    end
    for zz = 1:size(compend,2)
        aa{jj,zz} = conc_PAC_eval(num2str(compend(jj,zz)),gridc,yeard,mon1,mon2);
        if isstruct(aa{jj,zz})
            ii = buoy(:,3) == compend(jj,zz);
            if isempty(buoy(ii,1))
                continue
            end
            nn = nn + 1;
            tim1(nn) = min(aa{jj,zz}.timest);
            tim2(nn) = max(aa{jj,zz}.timest);
            
            lon(nn) = buoy(ii,1);
            lat(nn) = buoy(ii,2);
            bname{nn} = num2str(compend(jj,zz));

            for rr = 1:3
                bb(rr) = figure(rr);
                subplot(8,3,[7 10])
                iw = aa{jj,zz}.aabuoy(:,idty(rr)) >= 0.1;
                if isempty(aa{jj,zz}.aabuoy(iw,idty(rr)))
                    continue
                end
                plot(aa{jj,zz}.aabuoy(iw,idty(rr)), ...
                    aa{jj,zz}.aamod(iw,idty(rr)),[stype{nn}(1:2)], ...
                    'markersize',5)
                hold on
                [qqB,qqM] = QQ_proc(aa{jj,zz}.aabuoy(iw,idty(rr)), ...
                    aa{jj,zz}.aamod(iw,idty(rr)));
                subplot(8,3,[9 12])
                plot(qqB,qqM,[stype{nn}(1:2)], ...
                    'markersize',5)
                hold on
                
                ss = getfield(aa{jj,zz},fields1{rr});
                ii = ss < 0.1;
                ss(ii) = NaN;
                subplot(8,3,[13 15])
                pp1(nn) = plot(aa{jj,zz}.timest,ss,stype{nn});
                hold on
                
                ss = getfield(aa{jj,zz},fields2{rr});
                ss(ii,:) = NaN;
                subplot(8,3,[16 18])
                plot(aa{jj,zz}.timest,ss(:,3),stype{nn})
                hold on
                
                subplot(8,3,[19 21])
                plot(aa{jj,zz}.timest,ss(:,5),stype{nn})
                hold on
                
                subplot(8,3,[22 24])
                plot(aa{jj,zz}.timest,ss(:,6),stype{nn})
                hold on
            end
        end
    end
    for rr = 1:3
        if ismember(rr,bb)
            figure(rr);
            orient tall
            subplot(8,3,[2 6])
            timeplot_mmap(compc(jj,:))
            for zz = 1:nn
                lond = lon(zz);
                lond(lond < 0) = lond(lond < 0) + 360;
                m_text(lond,lat(zz),bname{zz},'VerticalAlignment','bottom', ...
                    'backgroundcolor',[1,1,1],'fontsize',8, ...
                    'horizontalalignment','left')
                m_plot(lond,lat(zz),'r.','markersize',12)
            end
            hold off
            
            subplot(8,3,[7 10])
            xlimit = get(gca,'xlim');
            plot(xlimit,xlimit,'k-')
            axis('square')
            grid
            ylimt = get(gca,'ylim');ylimt(1) = 0;
            yticks = [ylimt(1):ylimt(2)/4:ylimt(2)];
            xticks = yticks;
            set(gca,'ytick',yticks,'ylim',ylimt, ...
                'xlim',ylimt,'xtick',xticks)
            xlabel(['Buoy ',btype{rr}],'fontweight','bold');
            ylabel(['Model ',btype{rr}],'fontweight','bold');
            title('Model vs Buoy Scatter','fontweight','bold');
            hold off
            
            subplot(8,3,[9 12])
            xlimit = get(gca,'xlim');
            plot(xlimit,xlimit,'k-')
            axis('square')
            grid
            ylimt = get(gca,'ylim');ylimt(1) = 0;
            yticks = [ylimt(1):ylimt(2)/4:ylimt(2)];
            xticks = yticks;
            set(gca,'ylim',ylimt,'ytick',yticks, ...
                'xlim',ylimt,'xtick',xticks);
            xlabel(['Buoy ',btype{rr}],'fontweight','bold');
            ylabel(['Model ',btype{rr}],'fontweight','bold');
            title('Model vs Buoy Q-Q','fontweight','bold');
            hold off
            
            subplot(8,3,[13 15])
            pp2 = legend(bname);
            set(pp2,'position',[0.44 0.55 0.09 0.11])
            grid
            set_WIS_xtick(min(tim1),max(tim2),12);
            ylim = get(gca,'ylim');
            set_WIS_ytick(0,ylim(2))
            ylabel(['Mean ',btype{rr}],'fontweight','bold')
            hold off
            for ii = 1:3
                subplot(8,3,[3*ii+13 3*ii+15])
                set_WIS_xtick(min(tim1),max(tim2),12);
                grid
                ylabel(itype{ii},'fontweight','bold')
                hold off
                ylimt = [toll(rr,ii) tolh(rr,ii)];
                if ylimt(1) < 0
                    yticks = ylimt(1):ylimt(2)/2:ylimt(2);
                else
                    yticks = ylimt(1):ylimt(2)/4:ylimt(2);
                end
                set(gca,'ylim',ylimt,'ytick',yticks)
                if ii == 1
                    text(min(tim1),14*max(ylimt),tit,'FontSize',12, ...
                        'fontweight','bold')
                end
            end
            xlabel('Time (Month Year)','fontweight','bold')
            outname = [outdir,'PAC-stats-cont',num2str(jj),'-',type{rr}, ...
                '-',num2str(yearmon1),'-',num2str(yearmon2)];
            saveas(gcf,outname,'png');
        end
    end
    clf;close all;clear nn
end



