import React, {Component} from 'react';
import Typography from '@material-ui/core/Typography';

import {withStyles} from '@material-ui/core/styles';
import ContactSupport from './ContactSupport';
import PropTypes from 'prop-types';

const styles = {
    errorLabel: {
        textAlign: 'center',
        width: '100%',
    },
};

@withStyles(styles)
export default class LoadingFailed extends Component {
    static propTypes = {
        classes: PropTypes.object.isRequired,
        errorText: PropTypes.string.isRequired,
    };


    render() {
        const {classes, errorText} = this.props;


        return (
            <>
                <div className={classes.errorLabel}>
                    <Typography
                        color="error"
                        gutterBottom
                        variant='h5'
                        style={{'marginTop': '5rem'}}
                    >
                        Помилка при завантаженні. Причина: "{errorText}"
                    </Typography>

                    <Typography
                        color="error"
                        variant='h5'>
                        <ContactSupport upper={true}/>
                    </Typography>
                </div>
            </>
        );
    }
}