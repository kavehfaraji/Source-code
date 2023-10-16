function z=objective(ensemble,Validationset)

%     Validationset = Validationset{:,:};
    z1 = objective1(ensemble,Validationset);
    z2 = objective2(ensemble,Validationset);

    z=[z1; z2];


end 