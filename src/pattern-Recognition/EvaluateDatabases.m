function Perr=EvaluateDatabases(Design,Y)

%figure
if nargin==1
    if(size(Design.T,1)==1)
%         plot3(Design.P(1,Design.T==1),Design.P(2,Design.T==1),Design.T(1,Design.T==1),'r.')
%         hold on
%         plot3(Design.P(1,Design.T==0),Design.P(2,Design.T==0),Design.T(1,Design.T==0),'b.')
%         view(0,90)
%         xlabel('Feature 1')
%         ylabel('Feature 2')
%         zlabel('Target')
%         set(gca,'FontSize',14)
    end
    Perr=[];
else
    if(size(Design.T,1)==1)
            if(sum(Y<0.5))
            Perr=mean(Design.T~=(Y>0.5));
        else
            Perr=mean(Design.T~=(Y==1));
            Y=(Y==1);
        end
        
%         plot3(Design.P(1,Y>0.5),Design.P(2,Y>0.5),Y(Y>0.5),'r.','MarkerSize',15)
%         hold on
%         plot3(Design.P(1,Y<=0.5),Design.P(2,Y<=0.5),Y(Y<0.5),'b.','MarkerSize',15)
%         view(0,90)
%         xlabel('Feature 1')
%         ylabel('Feature 2')
%         zlabel('Output')
%         set(gca,'FontSize',14)
        
    else
        [~,a]=max(Design.T);
        if(size(Y,1)==1)
            if(sum(Y<0.5))
                b=Y>0.5;
            else
                b=Y;
            end
        else
            [~,b]=max(Y);
        end
        Perr=mean(a~=b);
    end
end    