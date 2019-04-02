import React from 'react';
import Devices from './Devices/index';
import ToolbarAppWeb from './ToolbarApp';


const DevicePage = () => (
    <div>
        <ToolbarAppWeb>
            <Devices/>
        </ToolbarAppWeb>
    </div>
);

export default DevicePage;